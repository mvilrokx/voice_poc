class Interaction

  get '/API/v3/interactions/search' do
    content_type :json
    puts params
    Interaction.find(params).to_json
  end

  get '/API/v3/interactions/:id' do
    content_type :json
    Interaction.find_by_id(params[:id]).to_json
  end

  get '/API/v3/interactions' do
    content_type :json
    Interaction.all(params).to_json
  end

end