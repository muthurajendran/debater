class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_many :topics
  has_many :comments
  
  
  has_many :topic_user_supports
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         
         def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
             user = User.where(:provider => auth.provider, :uid => auth.uid).first
             if user
               return user
             else
               registered_user = User.where(:email => auth.info.email).first
               if registered_user
                 registered_user.update_attributes(:provider=> auth.provider, :uid=>auth.uid)
                 return registered_user
               else
                 user = User.create( provider:auth.provider,
                                     uid:auth.uid,
                                     email:auth.info.email,
                                     password:Devise.friendly_token[0,20],
                                   )
               end
       
             end
           end
end
