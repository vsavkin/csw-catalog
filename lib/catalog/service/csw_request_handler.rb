module Catalog
  module Service

    class CswRequestHandler
      def initialize(params)
        @params = downcase_params(params)
      end

      def handle
        common_checks
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
        service = @params[:service]
        if service.nil?
          raise CswRequestValidationException.new('Service must be set as CSW', MISSING_PARAMETER_VALUE, 'service')
        end
        if service != 'csw'
          raise CswRequestValidationException.new('Service must be set as CSW', INVALID_PARAMETER_VALUE, 'service')
        end

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