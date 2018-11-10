class RescueteamController < ApplicationController

   def index 
      @team=session[:team_id]
      session[:aflag]= true
      session[:store_detail]=nil
      flash[:flag]= true
      session[:search]=true
      flash[:register_errors]=nil
      if @team 
        redirect_to '/teamview'
      end
      
   end
  
   def logout
    session[:team_id]=nil
    redirect_to '/'

  end
  def show
     
     @team=Rescueteam.find_by_id(session[:team_id])
     if !@team
       redirect_to '/slogin'
     else
        @details=Missingdetail.where(r_id:@team.id,status:"approved").order(elevel: :desc)
     end  
               
   end
  def profile
   
   @team=Rescueteam.find_by_id(session[:team_id])
   if !@team
       redirect_to '/slogin'
   end
  end
  def new 
    @team = Rescueteam.new
  end
  def rescueview
     
      @team=Rescueteam.find_by_id(session[:team_id])
      if !@team
        redirect_to '/slogin'
      else
        @details=Missingdetail.where(id:params[:id])
      end     
   end  
  def rescuesms
          @id=session[:u_detail]
          
          @ud=Missingdetail.find_by_id(@id)
          @admin=Admin.find_by_area(@ud[:area])
          if @ud[:u_id] =="admin"
             @userid=@admin
          else
             @userid=Guestuser.find_by_id(@ud[:u_id])
          end
          
          cname=@userid.name
          cno=@userid.contactno
          
          require 'uri'
          require 'net/http'
          x=cname.to_s.concat("\nRescue Operation is done for your report. Kindly check out website for more details.").concat("\nReport ID: ").concat(@ud[:id].to_s)
          u="http://api.msg91.com/api/sendhttp.php?country=91&sender=MSGIND&route=4&mobiles=".concat(cno.to_s).concat("&authkey=239279Awhbs6gNq75ba9b729&message=Hello! ").concat(x).concat("\nThank You for using OMPTS!.")
          url = URI.encode(u)

          http = Net::HTTP.new(URI.parse(url).host,URI.parse(url).port)

          request = Net::HTTP::Post.new(URI.parse(url))

          response = http.request(request)

          redirect_to '/rescueteamview'




  end 
def rescueupdate
  
   @team=Rescueteam.find_by_id(session[:team_id])
     if !@team
          redirect_to '/slogin'
     else
        @details=Missingdetail.find_by_id(params[:id])
        @details.update_column(:status,"rescued")
        session[:u_detail]=@details[:id]
        redirect_to '/rescuesms'
     end 
end
  def check
    
     team = Rescueteam.find_by_email(login_params[:email])
    
       if team && team.authenticate(login_params[:password])
          session[:team_id] = team.id
            redirect_to '/teamview'
       else
         flash[:login_errors]= ["invalid credentials"]
         redirect_to '/slogin'
            
        end
    


  end
 def create
         @team = Rescueteam.new(team_params) 
       
       @admin = Admin.find(params[:area])
    		@team[:area]=@admin[:area]
        if Rescueteam.find_by_email(team_params[:email])
          flash[:register_errors] =@team.errors.full_messages.push("Email_Id Exist")
          render :template => 'rescueteam/new' 
        
    		elsif team_params[:password]  != params[:password_confirmation]
              flash[:register_errors] =@team.errors.full_messages.push("Password mismatch")
    			    render :template => 'rescueteam/new' 
         
    		elsif @team.save
      		
   		   
   		   redirect_to '/'
   		else 
             flash[:register_errors] = @team.errors.full_messages
              render :template => 'rescueteam/new'
      end
  end
   private
  	  def team_params 
        params.require(:rescueteam).permit(:email,:name,:area,:contactno,:password,:teamsize) 
      end
      def login_params
        params.require(:rescueteam).permit(:email , :password)
      end



end
