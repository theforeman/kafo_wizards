require 'ipaddr'
module KafoWizards::Entries

  class NetmaskEntry < IPAddressEntry
    def validate(value)
      if value.to_s.include?('/')
        begin
          mask_len = value.split('/').last.to_i
          value = IPAddr.new('255.255.255.255').mask(mask_len).to_s
        rescue IPAddr::InvalidPrefixError => e
          raise KafoWizards::ValidationError.new("#{value} is not valid netmask (#{e.message})")
        end
      end
      if !(value =~ Resolv::IPv4::Regex)
        raise KafoWizards::ValidationError.new("#{value} is not valid netmask")
      end
      value
    end

    def self.entry_type
      :netmask
    end

  end
end
