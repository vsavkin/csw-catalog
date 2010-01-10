module Catalog
  module Service

    # page 143 OGC-07-006r1
    class XmlExceptionFormatter
      def format(ex)
        desc = exception_description(ex)
        b = Builder::XmlMarkup.new
        root_args = {'xmlns' => 'http://www.opengis.net/ows',
                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                      'version' => '1.2.0',
                      'xsi:schemaLocation' => 'http://www.opengis.net/ows ows.xsd'}

        b.ExceptionReport root_args do
          b.Exception :exceptionCode => desc[:code], :locator => desc[:locator] do
            b.ExceptionText desc[:message]
          end
        end
      end

      private
      def exception_description(ex)
        if ex.kind_of?(CswRequestValidationException)
          {:code => ex.code, :locator => ex.locator, :message => ex.message}
        else
          {:code => NO_APPLICABLE_CODE, :locator => nil, :message => ex.message}
        end
      end
    end

    class SimpleExceptionFormatter
      def format(exception)
        exception.message
      end
    end
  end
end