module Catalog
  module Service

    class CswRequestHandler
      attr_reader :params

      def initialize(params)
        @params = downcase_params(params)
      end

      def handle
        common_checks
      end

      def check_parameter(name, *required_value)
        value = @params[name]
        if value.nil?
          raise CswRequestValidationException.new("You must specify #{name}", MISSING_PARAMETER_VALUE, name)
        end
        if !required_value.include?(value)
          raise CswRequestValidationException.new("#{name} must be set as #{required_value.to_s}", INVALID_PARAMETER_VALUE, name)
        end
      end
      
      def parse_namespaces
        namespaces = (params[:namespace] || '').split(',')
        namespaces.collect do |n|
          if n[0..5] != 'xmlns(' || n[-1..-1] != ')'
            raise CswRequestValidationException.new("Invalid namespaces", INVALID_PARAMETER_VALUE, :namespace)
          end
          URI.decode(n[6..-2])
        end
      end

      private
      def downcase_params (params)
        res = {}
        params.each do |k, v|
          res[k.to_s.downcase.to_sym] = downcase_value(k,v)
        end
        res
      end

      def downcase_value(k, v)
        if v.nil? || [:constraint].include?(k)
          v
        else
          v.downcase
        end
      end

      def common_checks
        check_parameter :service, 'csw'

        version = @params[:version]
        if version.nil?
          raise CswRequestValidationException.new('Version must be set as 2.0.2', MISSING_PARAMETER_VALUE, 'version')
        end
        if version != '2.0.2'
          raise CswRequestValidationException.new('Version must be set as 2.0.2', VERSION_NEGOTIATION_FAILED)
        end
      end
    end

  end
end