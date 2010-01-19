module Catalog::Service
  #page 37 of OGC 06-123r
  NO_APPLICABLE_CODE = 'NoApplicableCode'
  MISSING_PARAMETER_VALUE = 'MissingParameterValue'
  INVALID_PARAMETER_VALUE = 'InvalidParameterValue'
  VERSION_NEGOTIATION_FAILED = 'VersionNegotiationFailed'

  class CswRequestValidationException < Exception
    attr_reader :code, :locator

    def initialize(message, code = NO_APPLICABLE_CODE, locator = nil)
      super(message)
      @code = code
      @locator = locator.to_s
    end
  end
end
