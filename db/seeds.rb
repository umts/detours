require 'factory_girl_rails'

# USERS
adam = FactoryGirl.create :user, first_name: 'Adam',  last_name: 'Sherson',      email: 'adam@umass.edu'
matt = FactoryGirl.create :user, first_name: 'Matt',  last_name: 'Moretti',      email: 'moretti@umass.edu'
dave = FactoryGirl.create :user, first_name: 'David', last_name: 'Faulkenberry', email: 'dfaulken@umass.edu'

# ROUTES
routes = []
routes[30] = FactoryGirl.create :route, name: 'N. Amherst / Old Belchertown Rd.', number: '30'
routes[31] = FactoryGirl.create :route, name: 'Sunderland / S. Amherst',          number: '31'
routes[33] = FactoryGirl.create :route, name: 'Big Y / Puffers Pond',             number: '33'
routes[34] = FactoryGirl.create :route, name: 'Northbound Campus Shuttle',        number: '34'
routes[35] = FactoryGirl.create :route, name: 'Southbound Campus Shuttle',        number: '35'
routes[36] = FactoryGirl.create :route, name: 'Olympia Dr / Atkins Farm',         number: '36'
routes[38] = FactoryGirl.create :route, name: 'UMass / Mount Holyoke College',    number: '38'
routes[39] = FactoryGirl.create :route, name: 'Smith Clg. / Hampshire Clg.',      number: '39'
routes[45] = FactoryGirl.create :route, name: 'Belchertown Center',               number: '45'
routes[46] = FactoryGirl.create :route, name: 'Park & Ride via S. Deerfield',     number: '46'

# POSTS
PaperTrail.whodunnit = adam.id.to_s
FactoryGirl.create :post,
                   start_datetime: 2.weeks.ago,
                   end_datetime: 1.week.ago,
                   routes: routes[30..31],
                   text: "Routes 30 and 31 are cancelled for the week because it's nice outside" \
                         " and we like playing with dogs. Instead, please feel free to use a taxi" \
                         " service or your own legs.",
                   short_text: 'Routes 30 and 31 cancelled for the week due to weather.'
PaperTrail.whodunnit = matt.id.to_s
FactoryGirl.create :post,
                   start_datetime: 3.days.ago,
                   end_datetime: 3.days.since,
                   routes: routes[34..35],
                   text: "Routes 34 and 35 will be bypassing the Admissions building because" \
                         " there's construction going on up there, and quite frankly, we just" \
                         " don't want to scratch up our new buses.",
                   short_text: 'Routes 34 and 35 to bypass the Admissions building.'
PaperTrail.whodunnit = dave.id.to_s
FactoryGirl.create :post,
                   start_datetime: 1.week.since,
                   end_datetime: 2.weeks.since,
                   routes: routes[38..39],
                   text: "Routes 38 and 39 will be swapping route numbers for a week or so," \
                         " since we figured that we might as well just go the whole hog" \
                         " on making those schedules as unnecessarily confusing as possible.",
                  short_text: 'Routes 38 and 39 will be switching route numbers.'
