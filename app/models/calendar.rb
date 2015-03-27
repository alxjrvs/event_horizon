class Calendar < ActiveRecord::Base
  has_many :teams

  validates :name, presence: true
  validates :cid, presence: true
  validates :cid, uniqueness: true

  def self.events(calendar_ids)
    MultiCalendarFetch.new(calendar_ids).all_events
  end

  def events
    if redis_data_present?
      fetch_redis_data
    else
      save_redis_data
      calendar.events
    end
  end

  private

  def redis_data_present?
    redis.get(cid)
  end

  def save_redis_data
    redis.set(cid, calendar.event_json)
    redis.expire(cid, 15.minutes)
  end

  def fetch_redis_data
    calendar_events_from_redis unless redis_events.empty?
  end

  def calendar_events_from_redis
    redis_events.map { |event| CalendarEvent.new(event) }
  end

  def redis_events
    JSON.parse(redis.get(cid))
  end

  def redis
    Redis.current
  end

  def calendar
    @calendar ||= GoogleCalendarAdapter.new(cid)
  end
end
