class MultiCalendarFetch
  attr_reader :ids, :results

  def initialize(ids)
    @results = []
    @ids = ids
  end

  def all_events
    combine_all_events
    sort_all_events
  end

  def combine_all_events
    ids.each do |calendar_id|
      results.concat(Calendar.find(calendar_id).events)
    end
  end

  def sort_all_events
    results.sort_by { |event| event.start_time }
  end
end
