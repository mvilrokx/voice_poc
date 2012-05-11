module Pageable

  MAX_FETCH_SIZE = 500

  def fetch_start(page=1, page_size=MAX_FETCH_SIZE)
    page||=1
    page_size||=MAX_FETCH_SIZE
    ((page.to_i * page_size.to_i)-(page_size.to_i-1))
  end

  def fetch_size(page_size=MAX_FETCH_SIZE)
    page_size||=MAX_FETCH_SIZE
    [page_size.to_i, MAX_FETCH_SIZE].min
  end

end