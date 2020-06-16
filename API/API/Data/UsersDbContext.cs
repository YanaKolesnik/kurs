using System.Data.Entity;
using API.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace API.Data
{
    public class UsersDbContext : IdentityDbContext<IdentityUser>
    {
        static UsersDbContext()
        {
            Database.SetInitializer(new Initializer());
        }

        private class Initializer : CreateDatabaseIfNotExists<UsersDbContext>
        {
            protected override void Seed(UsersDbContext context)
            {
                IdentityRole role = context.Roles.Add(new IdentityRole("Admin"));

                IdentityUser user = new IdentityUser("admin@mail.ru");
                user.Roles.Add(new IdentityUserRole { Role = role });
                user.Claims.Add(new IdentityUserClaim
                {
                    ClaimType = "hasRegistered",
                    ClaimValue = "true"
                });

                user.PasswordHash = new PasswordHasher().HashPassword("qwerty");
                context.Users.Add(user);

                context.SaveChanges();
                base.Seed(context);
            }
        }
    }
}