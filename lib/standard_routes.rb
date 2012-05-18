module StandardRoutes

  get '/API/v3/:lbo/search' do
    content_type :json
    puts params
    params[:lbo].classify.constantize.find(params).to_json
  end

  get '/API/v3/:lbo/:id' do
    content_type :json
    params[:lbo].classify.constantize.find_by_id(params[:id]).to_json
  end

  get '/API/v3/:lbo' do
    content_type :json
    params[:lbo].classify.constantize.all(params).to_json
  end

end