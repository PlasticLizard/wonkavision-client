{"aggregation"=>"Rpm::WorkQueueActivity",
 "slicer"=>["dimension::context_date::key::eq::'2011-05-02'","dimension::context_date::key::gt::'2011-05-02'"],
 "filters"=>["dimension::context_date::key::eq::'2011-05-02'"],
 "totals"=>
  {"measures"=>
    [{"name"=>"completed", "formatted_value"=>"0", "value"=>0},
     {"name"=>"count", "formatted_value"=>"1", "value"=>1},
     {"name"=>"incoming", "formatted_value"=>"0", "value"=>0},
     {"name"=>"outgoing", "formatted_value"=>"0", "value"=>0},
     {"name"=>"overdue", "formatted_value"=>"1", "value"=>1}],
   "dimensions"=>[],
   "key"=>[]},
 "measure_names"=>["count", "incoming", "outgoing", "completed", "overdue"],
 "axes"=>
  [{"start_index"=>0,
    "dimensions"=>
     [{"name"=>"context_date", "members"=>[{"key"=>"2011-05-02"}]}],
    "end_index"=>0}],
 "cells"=>
  [{"measures"=>
     [{"name"=>"completed", "formatted_value"=>"0", "value"=>0},
      {"name"=>"count", "formatted_value"=>"1", "value"=>1},
      {"name"=>"incoming", "formatted_value"=>"0", "value"=>0},
      {"name"=>"outgoing", "formatted_value"=>"0", "value"=>0},
      {"name"=>"overdue", "formatted_value"=>"1", "value"=>1}],
    "dimensions"=>["context_date"],
    "key"=>["2011-05-02"]}]
  }
