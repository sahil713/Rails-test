module Converter
  class User < Grape::API
    version 'v1', using: :path
    format :json
    resource :user do

      desc 'create a new user ',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      # success: API::V2::Entities::User
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
        if user.save
          present user
        else
          error!({ error: 'User not created' }, 400)
        end
      end

      desc 'Returns array of users',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      get  do
        User.all
      end

      desc 'Returns array of users as paginated collection',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :email,
                 type: { value: String, message: 'user.email.non_string' },
                 desc: 'User email for registeration'
        optional :password,
                 # values: { value: -> (p){ p.length > 8 }, message: 'user.password.invalid_range' },
                 type: String
      end
      put do
        declared_params = declared(params, include_missing: false)
        user = ::User.find_by(email: declared_params[:email])
        if user.update(declared_params)
          present user
        else
          error!({ error: 'User not updated' }, 400)
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

        if user.password == declared_params[:password]
          if user.delete
            present user
          else
            error!({ error: 'User not able to delete' }, 400)
          end
        else
          error!({ error: 'User password is incorrect' })
        end
      end

    end

  end
end
