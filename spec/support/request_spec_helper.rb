module RequestSpecHelper
  def parsed_response
    JSON.parse(response.body)
  end
end