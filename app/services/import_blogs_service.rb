require 'csv'

class ImportBlogsService
  BATCH_SIZE = 1000

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
    @logger = ActiveSupport::Logger.new(Rails.root.join('log', 'import_blogs.log'))
  end

  def call
    blogs = []
    row_count = 0

    CSV.foreach(@file_path, headers: true, encoding: 'utf8').lazy.each_slice(BATCH_SIZE) do |rows|
      rows.each do |row|
        begin
          blogs << row.to_h.merge(user_id: @user_id)
          row_count += 1
        rescue StandardError => e
          @logger.error "Error processing row: #{row.inspect}. Error: #{e.message}"
        end
      end

      begin
        insert_batch(blogs)
      rescue StandardError => e
        @logger.error "Error inserting batch: #{e.message}"
      ensure
        blogs.clear
      end
    end

    # Insert any remaining records
    insert_batch(blogs) unless blogs.empty?
    @logger.info "Successfully imported #{row_count} rows."
  end

  private

  def insert_batch(blogs)
    return if blogs.empty?

    Blog.transaction do
      Blog.insert_all(blogs)
    end
  rescue StandardError => e
    @logger.error "Failed to insert batch: #{e.message}"
  end
end