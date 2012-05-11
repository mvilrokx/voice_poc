class Main
  get '/' do
    haml :hello, :format => :html5
  end
end