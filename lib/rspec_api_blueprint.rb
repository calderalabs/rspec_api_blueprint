require "rspec_api_blueprint/version"

RSpec.configure do |config|
  config.after(:each, type: :request) do
    if response
      example_group = example.metadata[:example_group]
      example_groups = []

      while example_group
        example_groups << example_group
        example_group = example_group[:example_group]
      end

      action = example_groups[-2][:description_args].first if example_groups[-2]
      example_groups[-1][:description_args].first.match(/(\w+)\sRequests/)
      file_name = $1.underscore

      File.open(File.join(Rails.root, "/docs/#{file_name}.txt"), 'a') do |f|
        f.write "#{action} \n\n"

        request_body = request.body.read

        if request.headers['Authorization']
          f.write "Headers: \n\n"
          f.write "Authorization: #{request.headers['Authorization']} \n\n"
        end

        if request_body.present?
          f.write "Request body: \n\n"
          f.write "#{JSON.pretty_generate(JSON.parse(request_body))} \n\n"
        end

        f.write "Status: #{response.status} \n\n"

        if response.body.present?
          f.write "Response body: \n\n"
          f.write "#{JSON.pretty_generate(JSON.parse(response.body))} \n\n"
        end
      end unless response.status == 401 || response.status == 403 || response.status == 301
    end
  end
end
