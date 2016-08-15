require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test 'project creation with valid info' do
    get '/auth/github/callback'

    assert_difference('Project.count') do
      post '/projects', params: {
             name: 'Personal Website',
             live_url: 'https://prophetorpheus.github.io'
           },
           xhr: true,
           as: :json
    end

    assert_equal 'application/json', @response.content_type
    assert_response 200, @response.status

    parsed_response = JSON.parse(@response.body)

    assert parsed_response['id']
    assert_equal parsed_response['name'], 'Personal Website'
    assert_equal parsed_response['live_url'], 'https://prophetorpheus.github.io'
  end

  test 'project creation with invalid info' do
    get '/auth/github/callback'

    post '/projects', params: {}, xhr: true, as: :json

    assert_equal 'application/json', @response.content_type
    assert_response 422, @response.status

    assert_equal "Name can't be blank", JSON.parse(@response.body)['errors'].first
  end

  test 'GitHub URL validation' do
  end
end
