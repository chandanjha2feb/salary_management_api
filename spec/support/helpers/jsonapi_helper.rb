module JsonapiHelper
  def jsonapi_data(response_body)
    json = JSON.parse(response_body)
    json['data']
  end

  def jsonapi_errors(response_body)
    json = JSON.parse(response_body)
    json['errors']
  end

  def jsonapi_attributes_from_body(response_body)
    data = jsonapi_data(response_body)
    jsonapi_attributes(data)
  end
end
