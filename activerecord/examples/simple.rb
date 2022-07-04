# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  # gem "activerecord", github: "thomascountz/rails", ref: "5942211feba53c8deec8884bcee109a759c5e60d"
  gem "activerecord", path: "/workspaces/rails/", require: 'active_record'
  gem "pg", require: true
  gem "pry", require: true
  gem "pry-nav", require: true
  gem "debug", require: true
end

require "minitest/autorun"
require "logger"

ActiveRecord::Base.establish_connection(adapter: "postgresql", database: "activerecord_unittest")
ActiveRecord::Base.logger = nil

ActiveRecord::Schema.define do
  suppress_messages do
    create_table :tcountz_books, force: true do |t|
      t.string :name
    end
  end
end

class Book < ActiveRecord::Base
  self.table_name_prefix = "tcountz_"
  alias_attribute :title, :name
end

class BugTest < Minitest::Test
  def test_insert_all
    assert_raises(ActiveModel::UnknownAttributeError, "unknown attribute 'title' for Book.") do
      Book.insert({ title: "Hello, Bug!" })
    end
  end
end