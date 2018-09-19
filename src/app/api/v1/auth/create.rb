# frozen_string_literal: true

module API
  module V1
    module Auth
      class Create < Grape::API
        helpers do
          def authenticate
            Authenticator.authenticate(
                email:            params[:email],
                request_password: params[:password],
                devise_params:    device_params
            )
          end

          def device_params
            declared(params).tap do |params|
              params[:ip] = request.ip
            end
          end

          def create_access_token!(user)
            AccessToken.generate(user, device_params)
          end
        end

        version :v1 do
          # POST /api/v1/auth
          desc 'Authenticate a user',
               named:   'authenticate',
               success: { code: 201, model: API::V1::Entities::Auth }
          params do
            requires :username, type: String
            requires :password, type: String
            requires :devise, type: Hash do
              requires :fingerprint, type: String
            end
          end
          post do
            result = authenticate
            error! authenticator_error(result.error), 401 if result.failure?
            present create_access_token!(result.user), with: API::V1::Entities::Auth
          end
        end
      end
    end
  end
end
