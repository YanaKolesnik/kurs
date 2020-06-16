using API.Data;
using API.Filters;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System.Web.Http;
using System.Web.Http.Description;

namespace BasicAuthentication.Controllers
{
    public class Test
    {
        public string base64 { get; set; }
    }
    public class NewAdminController : ApiController
    {
        UsersDbContext db = new UsersDbContext();
                
        // POST: api/NewAdmin
        [AllowAnonymous]
        [HttpPost]
        public IHttpActionResult AddAdmin(Test test)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(test.base64);
            string data = System.Text.Encoding.ASCII.GetString(base64EncodedBytes);

            string email = data.Substring(0, data.IndexOf(":")),
                password = data.Remove(0, data.IndexOf(":") + 1);

            IdentityUserRole r = new IdentityUserRole();
            r.RoleId = "24d9ec15-a57c-4436-bde0-c3d4d65eda36";

            IdentityUser user = new IdentityUser(email);
            user.Roles.Add(r);
            user.Claims.Add(new IdentityUserClaim
            {
                ClaimType = "hasRegistered",
                ClaimValue = "true"
            });

            user.PasswordHash = new PasswordHasher().HashPassword(password);
            db.Users.Add(user);


            db.SaveChanges();
            return Ok("Success");
        }


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}