require 'csv'

class ImportBlogsService
  BATCH_SIZE = 1000

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
  end

  def call
    blogs = []

    CSV.foreach(@file_path, headers: true, encoding: 'utf8') do |row|
      blogs << row.to_h.merge(user_id: @user_id)

      if blogs.size >= BATCH_SIZE
        Blog.insert_all(blogs)
        blogs.clear
      end
    end

    Blog.insert_all(blogs) unless blogs.empty? # Insert remaining records
  end
end
