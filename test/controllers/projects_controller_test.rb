require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  class CreateTest < ProjectsControllerTest
    test "with valid info" do
      get "/auth/github/callback"

      assert_difference("Project.count") do
        post "/projects",
             params: {
               name: "Personal Website",
               live_url: "https://prophetorpheus.github.io"
             },
             xhr: true,
             as: :json
      end

      assert_equal "application/json", @response.content_type
      assert_response 200, @response.status

      parsed_response = JSON.parse(@response.body)

      assert parsed_response["id"]
      assert_equal parsed_response["name"], "Personal Website"
      assert_equal(
        parsed_response["live_url"],
        "https://prophetorpheus.github.io"
      )
    end

    test "with invalid info" do
      get "/auth/github/callback"

      post "/projects", params: {}, xhr: true, as: :json

      assert_equal "application/json", @response.content_type
      assert_response 422

      assert_equal(
        "Name can't be blank",
        JSON.parse(@response.body)["errors"].first
      )
    end
  end

  class ValidateGithubUrlTest < ProjectsControllerTest
    def setup
      super

      get "/auth/github/callback"
    end

    test "with valid url repo" do
      VCR.use_cassette "validate_github_url/valid_repo",
                       match_requests_on: [:method, :uri] do
        get "/projects/validate_github_url",
            params: {
              url: "https://github.com/hackclub/hackclub"
            },
            xhr: true

        assert_equal "application/json", @response.content_type
        assert_response 200
      end
    end

    test "with invalid url" do
      get "/projects/validate_github_url",
          params: {},
          xhr: true

      assert_equal "application/json", @response.content_type
      assert_response 422
    end

    test "with repo that doesn't exist" do
      VCR.use_cassette "validate_github_url/nonexistant_repo",
                       match_requests_on: [:method, :uri] do
        get "/projects/validate_github_url",
            params: {
              url: "https://github.com/this_repository/does_not_exist"
            },
            xhr: true

        assert_equal "application/json", @response.content_type
        assert_response 404
      end
    end
  end
end
