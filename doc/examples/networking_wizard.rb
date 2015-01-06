#!/usr/bin/ruby

require 'kafo_wizards'
require 'facter'
require 'awesome_print'

def get_dns
  begin
    line = File.read('/etc/resolv.conf').split("\n").detect { |line| line =~ /nameserver\s+.*/ }
    line.split(' ').last || ''
  rescue
    ''
  end
end

def current_system_timezone
  if File.exists?('/usr/bin/timedatectl')  # systems with systemd
    # timezone_line will be like 'Timezone: Europe/Prague (CEST, +0200)'
    timezone_line = %x(/usr/bin/timedatectl status | grep "Timezone: ").strip
    return timezone_line.match(/Timezone: ([^ ]*) /)[1]
  else  # systems without systemd
    # timezone_line will be like 'ZONE="Europe/Prague"'
    timezone_line = %x(/bin/cat /etc/sysconfig/clock | /bin/grep '^ZONE=').strip
    # don't rely on single/double quotes being present
    return timezone_line.gsub('ZONE=', '').gsub('"','').gsub("'",'')
  end
rescue StandardError => e
  # Don't allow this function to crash the installer.
  # Worst case we'll just return UTC.
  @logger.debug("Exception when getting system time zone: #{e.message}")
  return 'UTC'
end

# facter can't distinguish between alias and vlan interface so we have to check and fix the eth0_0 name accordingly
# if it's a vlan, the name should be eth0.0, otherwise it's alias and the name is eth0:0
# if both are present (unlikly) facter overwrites attriutes and we can't fix it
def fix_interface_name(facter_name)
  if facter_name.include?('_')
    ['.', ':'].each do |separator|
      new_facter_name = facter_name.tr('_', separator)
      return new_facter_name if system("ifconfig #{new_facter_name} &> /dev/null")
    end

    # if ifconfig failed, we fallback to /sys/class/net detection, aliases are not listed there
    new_facter_name = facter_name.tr('_', '.')
    return new_facter_name if File.exists?("/sys/class/net/#{new_facter_name}")
  end
  facter_name
end


def interfaces
  @interfaces ||= (Facter.value :interfaces || '').split(',').reject { |i| i == 'lo' }.inject({}) do |ifaces, i|
    ip = Facter.value "ipaddress_#{i}"
    network = Facter.value "network_#{i}"
    netmask = Facter.value "netmask_#{i}"

    cidr, from, to = nil, nil, nil
    if ip && network && netmask
      cidr = "#{network}/#{IPAddr.new(netmask).to_i.to_s(2).count('1')}"
      from = IPAddr.new(ip).succ.to_s
      to = IPAddr.new(cidr).to_range.entries[-2].to_s
    end

    ifaces[fix_interface_name(i)] = {:ip => ip, :netmask => netmask, :network => network, :cidr => cidr, :from => from, :to => to, :gateway => ip} # gateway if not set
    ifaces
  end
end

def interfaces_options
  Hash[interfaces.map { |nic,details| [nic.to_sym, "#{nic} (#{details[:ip] || 'N/A'})"] }]
end


preselected_interface = nil

case interfaces.size
when 0
  HighLine.color("\nFacter didn't find any NIC, can not continue", :bad)
  raise StandardError
when 1
  preselected_interface = interfaces.keys.first.to_sym
else
  interface_wizard = KafoWizards.wizard(:cli, "Please select NIC on which you want provisioning enabled")
  f = interface_wizard.factory
  interfaces.each_pair do |nic, details|
    interface_wizard.entries << f.button(nic.to_sym, :label => "#{nic} (#{details[:ip] || 'N/A'})")
  end
  preselected_interface = interface_wizard.run
end

timezone_validator = lambda do |value|
  zoneinfo_file_names = %x(/bin/find /usr/share/zoneinfo -type f).lines
  zones = zoneinfo_file_names.map { |name| name.strip.sub('/usr/share/zoneinfo/', '') }
  raise KafoWizards::ValidationError.new("#{value} is not valid timezone") unless zones.include?(value)
  value
end

net_wizard = KafoWizards.wizard(:cli, 'Networking setup',
  :description => "The installer can configure the networking and firewall rules on this machine with the above configuration. \n" \
      "Default values are populated from the this machine's existing networking configuration.\n\n" \
      "If you DO NOT want to configure networking please set 'Configure networking on this machine' to No before proceeding. \n" \
      "Do this by selecting option 'Do not configure networking' from the list below.")

f = net_wizard.factory
net_wizard.entries = [
  f.selector(:interface, :label => 'Network interface', :options => interfaces_options,
    :pre_hook => lambda { |s| s.options = interfaces_options },
    :post_hook => lambda { |s| s.parent.update(interfaces[s.value.to_s]) }),
  f.ip_address(:ip, :label => 'IP address'),
  f.netmask(:netmask, :label => 'Network mask'),
  f.ip_address(:network, :label => 'Network address'),
  f.ip_address(:own_gateway, :label => 'Host Gateway'),
  f.ip_address(:from, :label => 'DHCP range start'),
  f.ip_address(:to, :label => 'DHCP range end'),
  f.ip_address(:gateway, :label => 'DHCP Gateway'),
  f.ip_address(:dns, :label => 'DNS forwarder'),
  f.string(:domain, :label => 'Domain', :required => true),
  f.string(:base_url, :label => 'Foreman URL', :required => true),
  f.string(:ntp_host, :label => 'NTP sync host', :required => true),
  f.string(:timezone, :label => 'Timezone', :required => true, :validators => [timezone_validator]),
  f.boolean(:configure_networking, :label => 'Configure networking on this machine'),
  f.boolean(:configure_firewall, :label => 'Configure firewall on this machine'),
  f.button(:ok, :label => 'Proceed with the above values', :default => true),
  f.button(:cancel, :label => 'Cancel Installation', :default => false, :trigger_validation => false)
]

net_wizard.update(
  :interface => preselected_interface.to_sym,
  :configure_networking => true,
  :configure_firewall => true,
  :own_gateway => `ip route | awk '/default/{print $3}'`.chomp,
  :domain => Facter.value(:domain),
  :base_url => "https://#{Facter.value :fqdn}",
  :dns => get_dns,
  :timezone => current_system_timezone,
  :ntp_host => '1.centos.pool.ntp.org'
)

net_wizard.update(interfaces[preselected_interface.to_s])

res = net_wizard.run

ap res.to_s
ap net_wizard.values
