require 'sinatra'
require "uri"
require "logger"
enable :sessions
$logger = Logger.new(STDOUT)

get "/" do
    session[:secret_num] = rand(100)+1.to_i
    erb :bienvenido
end
  
get "/new" do
  #initialize
  session[:guesses] = ""
  session[:guess_count] = 0
  $logger.warn "The secret number is #{session[:secret_num]}"
  @bckgrn_color = "blue"
  #erb: new   
  if session[:lost]
       "The game is over and you loose all your chances"
       redirect "/"
  else
    @name = session[:name]
    secret_num = session[:secret_num]
    erb :new
  end #endif
end#end get

#Post to(send to server) create title and content of the txt file in pages folder
post "/new" do
  params.inspect #we will get a hash from my form {"name"=>"adriana", "user_number"=>"1"}
  session[:name] = params[:name]
  session[:message] = ""
  logger.warn "guesses#{session[:guesses]}"
  if @user_number == ""
    message = 'You should type a number, this field can not be blank'
    logger.warn "the number is#{message}"  
  else 
    @user_number = params[:user_number].to_i
    $logger.warn "The params user number is #{@user_number}"
    $logger.warn "The session secret number is #{session[:secret_num]}"
    guesses = session[:guesses]
    guesses = [] #bitacora
    session[:guess_count] += 1
    $logger.warn "COUNTER #{session[:guess_count]}"
    while session[:guess_count] <= 6 do
      $logger.warn "COUNTER #{session[:guess_count]}"
      if @user_number == session[:secret_num]
        #if @user_number == @secret_num
        #guesses.push(params[:user_number])
      message = 'You Won, you beat me, Lets play again\n'  
      logger.warn "the number is#{message}"
      #erb:new
      redirect "/"
    # elsif session[:guess_count] >= 6 #
    #   session[:lost] = false
    #   # #You lost all your tries The game will start again\n"
    #   message ="You lost all your tries The game will start again\n"
    #   redirect "/"
    #   erb:new
      elsif @user_number > session[:secret_num]
        session[:guess_count] += 1
        #session[:guesses].push(params[:user_number])
        guesses.push(params[:user_number])
        #session[:guesses].push(@user_numbers.to_s)
        dif =  @user_number - session[:secret_num]
        if (dif <= 10)
          session[:message] = 'Too High'
          logger.warn "the number is#{session[:message]}"
        elsif dif > 10
          session[:message] = 'Way Too High'
          logger.warn "the number is#{session[:message]}"
        end
      elsif session[:secret_num] > @user_number
        session[:guess_count] += 1
        #session[:guesses].push(params[:user_number])
        guesses.push(params[:user_number])
        #session[:guesses].push(@user_number.to_s)
        dif = session[:secret_num] - @user_number
        if (dif <= 10)
          session[:message] = 'Too Low'
          logger.warn "the number is#{session[:message]}"
        elsif dif > 10
          session[:message] = 'Way Too Low'
          logger.warn "the number is#{session[:message]}"
        end #end if
      end
    end #end while
    logger.warn "the guesses are#{session[:guesses]}"
  end#end if
logger.warn "Your guesses #{guesses}"
logger.warn "Counter#{session[:guess_count]}"
redirect "/new"
end #end post

#$logger.warn "The tries #{session[:guesses]}"

