module Converter
  class Post < Grape::API
    version 'v1', using: :path
    format :json
    resource :post do

      desc 'create a new post ',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      # success: API::V2::Entities::post
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
        post = ::Post.new(declared_params)
        if post.save
          ::Comment.create!(commentable: post, body: params[:comment_body])
          present post
        else
          error!({ error: 'post not created' }, 400)
        end
      end

      desc 'Returns array of posts',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      get do
        ::Post.all
      end

      desc 'Returns array of posts as paginated collection',
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
        post = ::Post.find_by(id: params[:id])
        if post.update(declared_params)
          present post
        else
          error!({ error: 'post not updated' }, 400)
        end
      end

      desc 'delete array of posts as paginated collection',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :id,
                 type: Integer
      end
      delete do
        post = ::Post.find_by(id: params[:id])
        error!({ error: 'post not able to found' }, 403) if post.nil?

        if post.delete
          present post
        else
          error!({ error: 'post not able to delete' }, 400)
        end
      end

    end

  end
end
