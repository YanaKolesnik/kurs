using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using API.Filters;
using BasicAuthentication;

namespace BasicAuthentication.Controllers
{
    public class BirdsController : ApiController
    {
        private articlesEntities db = new articlesEntities();

        // GET: api/Birds
        [AllowAnonymous]
        public IQueryable<Birds> GetBirds()
        {
            return db.Birds;
        }

        // GET: api/Birds/5
        [AllowAnonymous]
        [ResponseType(typeof(BirdsArticles))]
        public IHttpActionResult GetBirdsArticles(int id)
        {
            BirdsArticles birdsArticles = db.BirdsArticles.Find(id);
            if (birdsArticles == null)
            {
                return NotFound();
            }

            return Ok(birdsArticles);
        }

        // PUT: api/Birds/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutBirds(int id, Birds birds)
        {

            if (id != birds.ID)
            {
                return BadRequest();
            }

            string procedure = "";
            int number;
            string connectionString = @"Data Source=DESKTOP-RDKB255\SQLEXPRESS;Initial Catalog=articles;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                string commandStr =
                    $"EXEC BirdsRating @id = '{birds.ID}'," +
                    $" @rating = '{birds.Rating}'";
                connection.Open();
                SqlCommand command = new SqlCommand(commandStr, connection);
                number = command.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            if (number != null)
                return Ok();

            return null;
        }

        // POST: api/Birds
        [ResponseType(typeof(Birds))]
        public IHttpActionResult PostBirds(Birds birds)
        {

            db.Birds.Add(birds);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (BirdsExists(birds.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = birds.ID }, birds);
        }

        // DELETE: api/Birds/5
        [ResponseType(typeof(Birds))]
        public IHttpActionResult DeleteBirds(int id)
        {
            Birds birds = db.Birds.Find(id);
            if (birds == null)
            {
                return NotFound();
            }

            db.Birds.Remove(birds);
            db.SaveChanges();

            return Ok(birds);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool BirdsExists(int id)
        {
            return db.Birds.Count(e => e.ID == id) > 0;
        }
    }
}