module Converter
  class Blog < Grape::API
    version 'v1', using: :path
    format :json
    resource :blog do

      desc 'create a new blog ',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      # success: API::V2::Entities::blog
      params do
        requires :user_id,
                 type: Integer
        requires :title,
                 type: String
        optional :comment_body,
                 type: String
      end
      post do
        declared_params = declared(params, include_missing: false).except(:comment_body)
        blog = ::Blog.new(declared_params)
        if blog.save
          ::Comment.create!(commentable: post, body: params[:comment_body])
          present blog
        else
          error!({ error: 'blog not created' }, 400)
        end
      end

      desc 'Returns array of blogs',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      get do
        ::Blog.all
      end

      desc 'Returns array of blogs as paginated collection',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :id,
                 type: Integer
        optional :title,
                 type: String
      end
      put do
        declared_params = declared(params, include_missing: false).except(:id)
        blog = ::Blog.find_by(id: params[:id])
        if blog.update(declared_params)
          present blog
        else
          error!({ error: 'blog not updated' }, 400)
        end
      end

      desc 'delete array of blogs as paginated collection',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :id,
                 type: Integer
      end
      delete do
        blog = ::Blog.find_by(id: params[:id])
        error!({ error: 'blog not able to found' }, 403) if blog.nil?
        if blog.delete
          present blog
        else
          error!({ error: 'blog not able to delete' }, 400)
        end
      end

    end

  end
end
