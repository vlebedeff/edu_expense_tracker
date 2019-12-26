module Support
  module Web
    def last_json_response
      JSON.parse(last_response.body)
    end
  end
end
