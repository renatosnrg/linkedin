require 'spec_helper'

describe LinkedIn::Api::CompanyMethods do
  
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
  
  context "Retrieving companies" do
    
    describe "by id" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company(:id => '162479')
      end
      
      it "should get a valid company" do
        result.id.should == 162479
        result.name.should == 'Apple'
      end
    end
    
    describe "by id with fields" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company(:id => '162479', :fields => ['id', 'name', 'universal-name', 'email-domains', 'logo-url', 'industry'])
      end
      
      it "should get a valid company" do
        result.id.should == 162479
        result.name.should == 'Apple'
        result.universal_name.should == 'apple'
        result.industry.should == 'Consumer Electronics'
        result.logo_url.should == 'http://m3.licdn.com/mpr/mpr/p/6/000/1b4/31c/0f3abe4.png'
        result.email_domains.all.size.should == 30
      end
    end
    
    describe "by universal name" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company(:universal_name => 'apple')
      end
      
      it "should get a valid company" do
        result.id.should == 162479
        result.name.should == 'Apple'
      end
    end
    
    describe "by universal name (escape need)" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company(:universal_name => 'barnes-&-noble')
      end
      
      it "should get a valid company" do
        result.id.should == 4417
        result.name.should == 'Barnes & Noble'
      end
    end
    
    describe "by email domain" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.company(:email_domain => 'apple.com')
      end
      
      it "should get a valid list of companies" do
        results.all.size.should == 2
        results.all.first.id.should == 162479
        results.all.first.name.should == 'Apple'
        results.all.last.id.should == 1276
        results.all.last.name.should == 'Apple Retail'
      end
    end
    
  end
  
  context "Searching for companies" do
    
    describe "by keyword" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company_search('Apple')
      end
      
      it "should perform a search" do
        result.companies.all.size.should == 10
        result.companies.all.first.id.should == 162479
        result.companies.all.first.name.should == 'Apple'
      end
    end
    
    describe "by keyword (escape need)" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company_search('Ci&T')
      end
      
      it "should perform a search" do
        result.companies.all.size.should == 3
        result.companies.all.first.id.should == 203563
        result.companies.all.first.name.should == 'Ci&T'
      end
    end
    
    describe "by keyword with count and fields" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company_search('Apple', :count => 1, :fields => [{:companies => ['id', 'name', 'universal-name', 'email-domains', 'logo-url', 'industry']}])
      end
      
      it "should perform a search" do
        result.companies.all.size.should == 1
        result.companies.all.first.name.should == 'Apple'
        result.companies.all.first.universal_name.should == 'apple'
        result.companies.all.first.industry.should == 'Consumer Electronics'
        result.companies.all.first.logo_url.should == 'http://m3.licdn.com/mpr/mpr/p/6/000/1b4/31c/0f3abe4.png'
        result.companies.all.first.email_domains.all.size.should == 30
      end
    end
    
  end

end