module Support
  def last_json_response
    JSON.parse(last_response.body)
  end
end
