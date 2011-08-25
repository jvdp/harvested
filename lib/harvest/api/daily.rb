module Harvest
  module API
    class Daily < Base
      
      def today(user = nil)
        response = request(:get, credentials, "/daily", :query => of_user_query(user))
        Harvest::Daily.parse(response.parsed_response).first
      end
      
      def for_day(date, user = nil)
        date = ::Time.parse(date) if String === date
        response = request(:get, credentials, "/daily/#{date.yday}/#{date.year}", :query => of_user_query(user))
        Harvest::Daily.parse(response.parsed_response).first
      end
    end
  end
end