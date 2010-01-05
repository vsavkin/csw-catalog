module Catalog
  module Service

    # page 143 OGC-07-006r1
    class XmlExceptionFormatter
      def format(ex)
        b = Builder::XmlMarkup.new
        root_args = {'xmlns' => 'http://www.opengis.net/ows',
                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                      'version' => '1.2.0',
                      'xsi:schemaLocation' => 'http://www.opengis.net/ows ows.xsd'}

        b.ExceptionReport root_args do
          b.Exception :exceptionCode => ex.code, :locator => ex.locator do
            b.ExceptionText ex.message
          end
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