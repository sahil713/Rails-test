module Converter
  class User < Grape::API
    version 'v1', using: :path
    format :json
    resource :user do

      desc 'create a new user ',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :email,
                 type: { value: String, message: 'user.email.non_string' },
                 desc: 'User email for registeration'
        requires :password,
                 # values: { value: -> (p){ p.length > 8 }, message: 'user.password.invalid_range' },
                 type: String
      end
      post do
        declared_params = declared(params, include_missing: false)
        user = ::User.new(declared_params)
        error!({ error: 'User not created' }, 400) unless user.save
        present user
      end

      desc 'Returns array of users',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      get do
        user = ::User.last
        present user
      end

      desc 'Returns array of users as paginated collection',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :email,
                 type: { value: String, message: 'user.email.non_string' },
                 desc: 'User email for registeration'
        requires :old_password,
                 type: String
        requires :password,
                 type: String
      end
      put do
        declared_params = declared(params, include_missing: false)
        update_params = declared_params.except(:old_password)
        user = ::User.find_by(email: declared_params[:email])
        if user.valid_password?(declared_params[:old_password])
          error!({ error: 'User not created' }, 400) unless user.update(update_params)
          present user
        end
      end

      desc 'delete array of users as paginated collection',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :email,
                 type: { value: String, message: 'user.email.non_string' },
                 desc: 'User email for registeration'
        requires :password,
                 type: String
      end
      delete do
        declared_params = declared(params, include_missing: false)
        user = ::User.find_by(email: declared_params[:email])
        error!({ error: 'User not able to found' }, 403) if user.nil?

        if user.valid_password?(declared_params[:password])
          error!({ error: 'User not created' }, 400) unless user.update(update_params)
          present user
        else
          error!({ error: 'User password is incorrect' })
        end
      end
    end
  end
end
