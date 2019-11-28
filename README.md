# Twitter Project
Twitter implementation in elixir

# Authors
Lee Deffebach 6448 5421 
Alex Banard

# Run with
Make sure mix.exs 17 is NOT commented out (comment for testing)
Make sure Mnesia folder is deleted
Run command
mix run twitter.exs num_clients num_messgaes

# Tests
Comment out mix.exs line 17
Make sure Mnesia folder is deleted
Run command
mix test

# Notes
Make sure to delete Mnesia folder before running. Not doing this will cause program to crash
Make sure that line 17 of mix.exs is not commented to run. Make sure it is to test
