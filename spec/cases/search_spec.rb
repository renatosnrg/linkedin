require 'spec_helper'

describe LinkedIn::Search do
  
  # if you remove the related cassettes you will need to inform valid
  # tokens and secrets to regenerate them
  #
  let(:client) do
    consumer_token  = ENV['LINKED_IN_CONSUMER_KEY'] || 'key'
    consumer_secret = ENV['LINKED_IN_CONSUMER_SECRET'] || 'secret'
    client = LinkedIn::Client.new(consumer_token, consumer_secret)
    auth_token      = ENV['LINKED_IN_AUTH_KEY'] || 'key'
    auth_secret     = ENV['LINKED_IN_AUTH_SECRET'] || 'secret'
    client.authorize_from_access(auth_token, auth_secret)
    client
  end
  
  describe "#search" do
    
    describe "by keywords string parameter" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search('apple')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 10
        results.people.all.first.should respond_to(:first_name)
        results.people.all.first.should respond_to(:last_name)
        results.people.all.first.should respond_to(:id)
      end
    end
    
    describe "by single keywords option" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:keywords => 'apple')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 10
        results.people.all.first.should respond_to(:first_name)
        results.people.all.first.should respond_to(:last_name)
        results.people.all.first.should respond_to(:id)
      end
    end
    
    describe "by single keywords option (escape need)" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:keywords => 'jose')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 10
        results.people.all.first.should respond_to(:first_name)
        results.people.all.first.should respond_to(:last_name)
        results.people.all.first.should respond_to(:id)
      end
    end
    
    describe "by single keywords option with pagination" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:keywords => 'apple', :start => 5, :count => 5)
      end
      
      it "should perform a search" do
        results.people.all.size.should == 5
        results.people.all.first.should respond_to(:first_name)
        results.people.all.first.should respond_to(:last_name)
        results.people.all.first.should respond_to(:id)
        results.people.all.last.should respond_to(:first_name)
        results.people.all.last.should respond_to(:last_name)
        results.people.all.last.should respond_to(:id)
      end
    end
    
    describe "by first_name and last_name options" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:first_name => 'Reid', :last_name => 'Hoffman')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 4
        results.people.all.first.first_name.should == 'Reid'
        results.people.all.first.last_name.should == 'Hoffman'
        results.people.all.first.id.should == '_nP1v4zwu4'
      end
    end
    
    describe "by first_name and last_name options with fields" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        fields = [{:people => [:id, :first_name, :last_name, :public_profile_url, :picture_url]}, :num_results]
        client.search(:first_name => 'Reid', :last_name => 'Hoffman', :fields => fields)
      end
      
      it "should perform a search" do
        results.people.all.size.should == 4
        results.people.all.first.first_name.should == 'Reid'
        results.people.all.first.last_name.should == 'Hoffman'
        results.people.all.first.id.should == '_nP1v4zwu4'
        results.people.all.first.picture_url.should == 'http://m3.licdn.com/mpr/mprx/0_ePvupfQ_rPjMy-iielQ0pub2r-Zdp-tiENT1pSkPfNuJin5_Xv58tDrgO049xzPfWKBt1onPUqEb'
        results.people.all.first.public_profile_url.should == 'http://www.linkedin.com/in/reidhoffman'
      end
    end
    
    describe "by company_name option" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:company_name => 'linkedin')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 3
        results.people.all.first.should respond_to(:first_name)
        results.people.all.first.should respond_to(:last_name)
        results.people.all.first.should respond_to(:id)
      end
    end
    
  end
  
end