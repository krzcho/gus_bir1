# frozen_string_literal: true

module GusBir1
  module Response
    SearchResult = Struct.new(:name, :regon, :province, :district, :community,
                              :city, :zip_code, :street, :street_number,
                              :house_number, :street_address, :type, :silos_id,
                              :type_desc, :silos_desc, :report, :post_city)

    class Search
      def initialize(body)
        @body = body
      end

      attr_reader :body

      def array
        n = Nokogiri.XML body
        n.xpath('//dane').map { |o| parse_dane(Nori.new.parse(o.to_s)['dane']) }
      end

      private

      def parse_dane(hash)
        SearchResult.new.tap do |search_result|
          search_result.name           = hash['Nazwa']
          search_result.regon          = hash['Regon']
          search_result.province       = hash['Wojewodztwo']
          search_result.district       = hash['Powiat']
          search_result.community      = hash['Gmina']
          search_result.city           = hash['Miejscowosc']
          search_result.zip_code       = hash['KodPocztowy']
          search_result.street         = hash['Ulica']
          search_result.street_number  = hash['NrNieruchomosci']
          search_result.house_number   = hash['NrLokalu']
          search_result.street_address = street_address_from(hash)
          search_result.type           = hash['Typ']
          search_result.silos_id       = hash['SilosID']
          search_result.type_desc      = type_info(search_result)
          search_result.silos_desc     = silos_info(search_result)
          search_result.report         = report_info(search_result)
          search_result.post_city      = hash['MiejscowoscPoczty']
        end
      end

      def type_info(search_result)
        return unless search_result.type
        Dictionary.szukaj_typ[search_result.type.to_sym]
      end

      def silos_info(search_result)
        return unless search_result.silos_id
        Dictionary.szukaj_silos_id[search_result.silos_id.to_sym]
      end

      def report_info(search_result)
        Report::TypeMapper.get_report_type(search_result)
      end

      def street_address_from(data)
        [data['Ulica'], [data['NrNieruchomosci'], data['NrLokalu']].compact.join('/')].join(' ')
      end
    end
  end
end
