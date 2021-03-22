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
      expect(response).to have_http_status(200)
    end
  end
end
