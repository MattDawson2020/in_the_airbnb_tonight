# frozen_string_literal: true

require_relative 'database_connection'

class Property

  attr_reader :id, :postcode, :title, :description, :user_id, :price_per_day

  def initialize(id:, postcode:, title:, description:, user_id:, price_per_day:)
    @id = id
    @postcode = postcode
    @title = title
    @description = description
    @user_id = user_id
    @price_per_day = price_per_day
  end

  def self.create(address:, postcode:, title:, description:, user_id:, price_per_day:)
    result = DatabaseConnection.query("INSERT INTO properties (address, postcode, title, description, user_id, price_per_day)
                                       VALUES('#{address}', '#{postcode}', '#{title}', '#{description}', '#{user_id}', '#{price_per_day}')
                                       RETURNING id, postcode, title, description, user_id, price_per_day;")

    Property.new(id: result[0]['id'],
                 postcode: result[0]['postcode'],
                 title: result[0]['title'],
                 description: result[0]['description'],
                 user_id: result[0]['user_id'],
                 price_per_day: result[0]['price_per_day'])
  end

  def self.all
    result = DatabaseConnection.query('SELECT * FROM properties')
    result.map do |property|
      Property.new(id: property['id'],
                   postcode: property['postcode'],
                   title: property['title'],
                   description: property['description'],
                   user_id: property['user_id'],
                   price_per_day: property['price_per_day'].to_i)
    end
  end

  def self.find(id)
    return unless id
    result = DatabaseConnection.query("SELECT * FROM properties WHERE id = '#{id}';")
    Property.new(id: result[0]['id'],
                 postcode: result[0]['postcode'],
                 title: result[0]['title'],
                 description: result[0]['description'],
                 user_id: result[0]['user_id'],
                 price_per_day: result[0]['price_per_day'])
  end
end
