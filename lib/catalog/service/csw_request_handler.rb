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

      def check_parameter(name, required_value)
        value = @params[name]
        if value.nil?
          raise CswRequestValidationException.new("You must specify #{name}", MISSING_PARAMETER_VALUE, name)
        end
        if value != required_value
          raise CswRequestValidationException.new("#{name} must be set as #{required_value}", INVALID_PARAMETER_VALUE, name)
        end
      end

      private
      def downcase_params (params)
        res = {}
        params.each do |k,v|
          res[k.to_s.downcase.to_sym] = v.nil? ? v : v.downcase
        end
        res
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