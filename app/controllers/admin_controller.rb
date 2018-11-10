class AdminController < ApplicationController

   def index 
      @admin=session[:admin_id]
      session[:aflag]= true
      session[:store_detail]=nil
      flash[:flag]= true
      session[:search]=true
      if @admin 
        redirect_to '/adminview'
      end 
      
   end
   def updatesms
        @id=session[:mid]
        @ud=Missingdetail.find_by_id(@id)
        @admin=Admin.find_by_id(session[:admin_id])
           
        if @ud[:u_id]=="admin"
           @userid=@admin
        else
           @userid=Guestuser.find_by_id(@ud[:u_id])
        end
      
          cno=@userid.contactno
          cname=@userid.name
        
        if session[:discard]
          @ud.delete

          y="discarded! Due to some reason. Please visit to admin for more details. Admin contactno:".concat(@admin.contactno.to_s)
        else
          y="approved! Please visit website for more details."
        end
        require 'uri'
        require 'net/http'
        x=cname.to_s.concat("\nYour report has been ").concat(y).concat("\nReport ID: ").concat(@id.to_s)
        u="http://api.msg91.com/api/sendhttp.php?country=91&sender=MSGIND&route=4&mobiles=".concat(cno.to_s).concat("&authkey=239279Awhbs6gNq75ba9b729&message=Hello! ").concat(x).concat("\nThank You for using OMPTS!.")
        url = URI.encode(u)

        http = Net::HTTP.new(URI.parse(url).host,URI.parse(url).port)

        request = Net::HTTP::Post.new(URI.parse(url))
       
          response = http.request(request)
      
        redirect_to '/adminedit'

   end
   def modify
    if !session[:admin_id]
      redirect_to '/alogin'
    end
    @id=session[:mid]
    @ud=Missingdetail.find_by_id(@id)
    #session[:a_ud]=@ud
    if params[:r_id]
       @ud.update(:elevel => params[:elevel],:r_id => params[:r_id],:status => "approved")
       session[:aflag]= true
       session[:discard]=false
       redirect_to '/updatesms'
    else
       flash[:r_id_nil]="No Team Available"
       session[:aflag]= true
    
       redirect_to '/adminedit'

    end
    
   end
    def discard
      if !session[:admin_id]
        redirect_to '/alogin'
      end
     
      session[:discard]=true
      
      #@userid.delete
       #@ud.delete
      session[:aflag]= true

      redirect_to '/updatesms'
      

    end
   def set
    if !session[:admin_id]
      redirect_to '/alogin'
    else
    session[:aflag]= false
    
    @admin=Admin.find(session[:admin_id])
    @d = Missingdetail.where(id:params[:id])
    session[:mid]=params[:id]

    @detail = Missingdetail.where(area: @admin[:area], elevel:"0")
    render action: :edit
    end
  end
   def edit
    
      @admin=Admin.find_by_id(session[:admin_id])
      if !@admin
         redirect_to '/alogin'
      else
        @detail = Missingdetail.where(area: @admin[:area], elevel:"0")
      

         if session[:aflag]
            @d = Missingdetail.all
         end
      end
    end

   def show
      
     @admin=Admin.find_by_id(session[:admin_id])
     if !@admin
       redirect_to '/alogin'
     else
         @detail = Missingdetail.new
          session[:admin_insert] = true
          flash[:flag]= true
          if session[:store_detail]
            @detail=session[:store_detail]
          end
     end
   end
  def logout
    session[:admin_id]=nil
    redirect_to '/'

  end
  def profile
     
    @admin=Admin.find_by_id(session[:admin_id])
    if !@admin
       redirect_to '/alogin'
    end
  end

  

  def check
    
    admin = Admin.find_by_email(login_params[:email])
    
       if admin && admin.authenticate(login_params[:password])
        	session[:admin_id] = admin.id
            redirect_to '/adminview'
       else
    	   flash[:login_errors]= ['Invalid Credentials']
    	   redirect_to '/alogin'
            
        end
    
   
   end
   def adminnotification
    
    @noti=Notification.new
    @notice=Admin.new

    end

    def create
      @notice = Notification.new(notice_params) 
      
    end
  
   private 
    def login_params
    	params.require(:admin).permit(:email , :password)
    end
    def modify_params
      params.require(:missingdetail).permit(:elevel)
    end
    def notice_params
      params.require(:notice).permit(:notice)
    end

  
end