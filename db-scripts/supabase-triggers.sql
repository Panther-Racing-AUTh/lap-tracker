----------------------------------------
--the two essential triggers for users--
----------------------------------------

-- the function that can copy the users from auth
create or replace function public.handle_new_user() 
returns trigger as $$
	begin
		insert into public.users (uuid, email, full_name)
		values (new.id, new.email, new.raw_user_meta_data->>'full_name');
		return new;
	end;
$$ language plpgsql security definer;

-- trigger the function every time a user is created
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

