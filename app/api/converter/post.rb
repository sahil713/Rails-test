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
        requires :title,
                 type: String
        optional :comment_body,
                 type: String
      end
      post do
        declared_params = declared(params, include_missing: false).except(:comment_body)
        post = current_user.posts.new(declared_params)
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
        current_user.posts
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
        post = current_user.posts.find_by(id: params[:id])
        error!({ error: 'post not updated' }, 400) unless post.update(declared_params)
        present post
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
        post = current_user.posts.find_by(id: params[:id])
        error!({ error: 'post not able to found' }, 403) if post.nil?
        error!({ error: 'post not able to delete' }, 400) unless post.destroy
        present post
      end

    end

  end
end
