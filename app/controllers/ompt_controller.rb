class OmptController < ApplicationController
skip_before_action :verify_authenticity_token
   def index
    @notify=Notification.maximum(:id)
    @n = Notification.find_by_id(@notify)
    @notification= @n.notification 
    @detail = Missingdetail.new
    @guser=Guestuser.new
    @admin=Admin.all
    flash[:flag]= true
    session[:admin_insert]= false
    session[:aflag]= true
    session[:store_detail]=nil
    session[:search]=true
    flash[:maintainance]="Our server will be on maintainance on OCT 4th..."

   end
   def show
      if params[:id]
        @d =Missingdetail.where(id: params[:id])
      else
        redirect_to '/'
      end
   end
   def find
     session[:search]=false
     
     session[:findid]=search_params[:id]
     redirect_to '/search'
   end
  def search
     
    if session[:search]
       @details =Missingdetail.all
    end

  end 
    def list

       @admin =Admin.all
      
       if flash[:flag]
          @d = Missingdetail.all
       end
            
      session[:search]=true

    end
    def email
       
        require 'uri'
        require 'net/http'
        x=session[:un].to_s.concat("\nYour report has been registered successfully with Email ID: ").concat(session[:ue].to_s).concat(" at Time: ").concat(session[:missingdate]).concat("\nReport ID: ").concat(session[:missingid].to_s)
        u="http://api.msg91.com/api/sendhttp.php?country=91&sender=MSGIND&route=4&mobiles=".concat(session[:uc].to_s).concat("&authkey=239279Awhbs6gNq75ba9b729&message=Hello! ").concat(x).concat("\nThank You for using OMPTS!.")
        url = URI.encode(u)

        http = Net::HTTP.new(URI.parse(url).host,URI.parse(url).port)

        request = Net::HTTP::Post.new(URI.parse(url))

        response = http.request(request)

        if session[:admin_insert]
          
          flash[:record_insert]=true
          redirect_to '/adminview'
        else
          flash[:user_insert_errors]=nil
          flash[:record_insert]=true
          redirect_to '/'
        end
    end
    
    def check
      flash[:flag]= false
      @admin =Admin.all
      @user=Guestuser.all
     @d =Missingdetail.where(area: params[:area]).order(elevel: :desc)
     

     render action: :list

    end

   def create 
      flag=""
      if session[:admin_insert]
          @detail = Missingdetail.new(adetail_params)
          @admin=Admin.find(session[:admin_id])
          @detail[:area]=@admin[:area]
          @detail.u_id = "admin"
          flag4=true
          if adetail_params[:glocation].nil?
            
            flag4=false
            
          else
            @location=adetail_params[:glocation]
            str=@location[0,28]
            regex="https://www.google.com/maps/"
          end
          if str==regex && flag4
              @detail[:glocation]=@location
              flag3=true

          else 
              flash[:admin_insert_errors]=["Google Map invalid"]
              flag3=false
              flag="adminview"
          end
          if params[:r_id]
             @detail.r_id = params[:r_id]
             @detail.status = "approved"
          else
            @detail.status = "reported"
            @detail.elevel="0"
          end
          if flag3
            if @detail.save
              session[:uc]=@admin[:contactno]
              session[:un]=@admin[:name]
              session[:ue]=@admin[:email]
              session[:missingdate]=@detail[:created_at]
              session[:missingid]=@detail[:id]
              flag="email"

            else
               flash[:admin_insert_errors] = @detail.errors.full_messages
               flag="adminview"
            end
          end
          @detail = Missingdetail.new(adetail_params)
          session[:store_detail]=@detail
      else
         
         	 @guser = Guestuser.new(user_params) 
           @detail = Missingdetail.new(detail_params)
           @admin = Admin.find(params[:area])
           @olduser = Guestuser.find_by_email(user_params[:email])
           @detail[:area]=@admin[:area]
           @location=detail_params[:glocation]
           str=@location[0,28]
           #str2=@location[0,33]
           regex="https://www.google.com/maps/"

           @detail.status = "reported"
            if @olduser
                 @guser=@olduser   
                 @detail.u_id = @guser.id
                 @guser.update(:name => user_params[:name],:contactno => user_params[:contactno])

                 if str==regex
                   @detail[:glocation]=@location
                   flag3=true
                 else 
                   flash[:user_insert_errors]=["Google Map invalid"]
                   flag3=false
                 end
                 if flag3
                   if @detail.save
                       session[:uc]=user_params[:contactno]
                       session[:un]=user_params[:name]
                       session[:ue]=user_params[:email]
                       session[:missingdate]=@detail[:created_at]
                       session[:missingid]=@detail[:id]
                   #render :action => 'show', :id => @detail.id
                       flag="email"
                   else
                      flash[:user_insert_errors]=@detail.errors.full_messages
                       flag="index"
                   end
                 end
           else
             if @guser.save
              flash[:user_insert_errors]=["User Details can not be left blank!"]
               flag2=false
               @detail.u_id = @guser.id
               
             else 
               flash[:user_insert_errors]=@guser.errors.full_messages
               flag2=true
               flag="index"
               
             end
           end
           if !flag2
               if str==regex
                 @detail[:glocation]=@location
                 flag3=true
               else 
                 flash[:user_insert_errors]=["Google Map invalid"]
                 flag3=false
               end
               if flag3
                 if @detail.save
                       
                       session[:uc]=user_params[:contactno]
                       session[:un]=user_params[:name]
                       session[:ue]=user_params[:email]
                       session[:missingdate]=@detail[:created_at]
                       session[:missingid]=@detail[:id]
             		   #render :action => 'show', :id => @detail.id
                    flag="email"
                 else
                      flash[:user_insert_errors]=@detail.errors.full_messages.push(flash[:user_insert_errors])
                       flag="index"
             		 end
               end
            end 
            @guser = Guestuser.new(user_params)
            @detail = Missingdetail.new(detail_params)
      end
            flash[:flag]= true
            if flag=="email"
              session[:store_detail]=nil
              flash[:user_insert_errors]=nil
              flash[:admin_insert_errors]=nil
              redirect_to "/email"
            elsif flag=="adminview"
              render "admin/show"
            else
              render action: :index
            end
	end
	private
	def user_params 
    params.require(:guestuser).permit(:email,:name,:contactno) 
    end
    def detail_params 
    params.require(:missingdetail).permit(:count,:name,:area, :address, :glocation) 
    end
    def adetail_params 
    params.require(:missingdetail).permit(:count,:name,:r_id,:elevel,:area,:address, :glocation) 
    end
    def d_params 
    params.require(:missingdetail).permit(:elevel) 
    end
    def search_params
      params.require(:missingdetail).permit(:id)
    end

end
