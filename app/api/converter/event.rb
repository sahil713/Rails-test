module Converter
  class Event < Grape::API
    version 'v1', using: :path
    format :json
    resource :event do

      desc 'create a new event ',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      # success: API::V2::Entities::event
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
        event = ::Event.new(declared_params)
        if event.save
          ::Comment.create!(commentable: post, body: params[:comment_body])
          present event
        else
          error!({ error: 'event not created' }, 400)
        end
      end

      desc 'Returns array of events',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      get do
        ::Event.all
      end

      desc 'Returns array of events as paginated collection',
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
        event = ::Event.find_by(id: params[:id])
        if event.update(declared_params)
          present event
        else
          error!({ error: 'event not updated' }, 400)
        end
      end

      desc 'delete array of events as paginated collection',
           failure: [
             { code: 401, message: 'Invalid bearer token' }
           ]
      params do
        requires :id,
                 type: Integer
      end
      delete do
        event = ::Event.find_by(id: params[:id])
        error!({ error: 'Event not able to found' }, 403) if event.nil?

        if event.delete
          present event
        else
          error!({ error: 'event not able to delete' }, 400)
        end
      end

    end

  end
end
