require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/new' do
    # behave like /create
    word = params[:word] || WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  post '/guess' do
    letter = params[:guess].to_s.slice(0,1)
    begin
      already = @game.guesses.include?(letter.downcase) || @game.wrong_guesses.include?(letter.downcase)
      ok = @game.guess(letter)
      flash[:message] = "You have already used that letter." if !ok || already
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  

  get '/show' do
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      @wrong_guesses     = @game.wrong_guesses
      @word_with_guesses = @game.word_with_guesses
      erb :show
    end
  end

  get '/win' do
    redirect '/show' unless @game.check_win_or_lose == :win
    erb :win
  end

  get '/lose' do
    redirect '/show' unless @game.check_win_or_lose == :lose
    erb :lose
  end
end
