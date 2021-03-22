# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    before { get '/posts' }

    it 'should return OK' do
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end

  describe 'with data in the DB' do
    # let : En el bloque de adentro se va a evaluar solo cuando se haga
    # referencia a la variable (solo se crean cuando se
    #  llame a posts ej. linea 24)
    # let! : Los posts son creados al momento,
    # no se espera a que posts sea llamado.
    let!(:posts) do
      create_list(:post, 10, published: true)
    end
    it 'should return all the published posts' do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /posts/:id' do
    let(:post) do
      create(:post)
    end
    it 'should return a post' do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /posts' do
    let!(:user) do
      create(:user)
    end
    it 'should create a post' do
      req_payload = {
        post: {
          title: 'título',
          content: 'content',
          published: false,
          user_id: user.id
        }
      }

      post '/posts', params: req_payload

      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to_not be_nil
      expect(response).to have_http_status(:created)
    end

    it 'should return error msg on invalid post' do
      req_payload = {
        post: {
          title: '',
          content: 'content',
          published: false,
          user_id: user.id

        }
      }

      post '/posts', params: req_payload

      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

describe 'PUT /posts/:id' do
  let!(:article) do
    create(:post)
  end
  it 'should update a post' do
    req_payload = {
      post: {
        title: 'título nuevo',
        content: 'content nuevo',
        published: true
      }
    }

    put "/posts/#{article.id}", params: req_payload

    payload = JSON.parse(response.body)
    expect(payload).to_not be_empty
    expect(payload['id']).to eq(article.id)
    expect(response).to have_http_status(:ok)
  end

  it 'should return error msg on invalid post' do
    req_payload = {
      post: {
        title: nil,
        content: nil,
        published: true
      }
    }

    put "/posts/#{article.id}", params: req_payload

    payload = JSON.parse(response.body)
    expect(payload).to_not be_empty
    expect(payload['error']).to_not be_empty
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
