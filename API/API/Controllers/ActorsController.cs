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
    public class ActorsController : ApiController
    {
        private articlesEntities db = new articlesEntities();

        [AllowAnonymous]
        // GET: api/Actors
        public IQueryable<Actors> GetActors()
        {
            return db.Actors;
        }

        [AllowAnonymous]
        // GET: api/Actors/5
        [ResponseType(typeof(ActorsArticles))]
        public IHttpActionResult GetActorsArticles(int id)
        {
            ActorsArticles actorsArticles = db.ActorsArticles.Find(id);
            if (actorsArticles == null)
            {
                return NotFound();
            }

            return Ok(actorsArticles);
        }

        // PUT: api/Actors/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutActors(int id, Actors actors)
        {

            string procedure = "";
            int number;
            string connectionString = @"Data Source=DESKTOP-RDKB255\SQLEXPRESS;Initial Catalog=articles;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                string commandStr =
                    $"EXEC ActorsRating @id = '{actors.ID}'," +
                    $" @rating = '{actors.Rating}'";
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

        // POST: api/Actors
        [ResponseType(typeof(Actors))]
        public IHttpActionResult PostActors(Actors actors)
        {

            db.Actors.Add(actors);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (ActorsExists(actors.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = actors.ID }, actors);
        }

        // DELETE: api/Actors/5
        [ResponseType(typeof(Actors))]
        public IHttpActionResult DeleteActors(int id)
        {
            Actors actors = db.Actors.Find(id);
            if (actors == null)
            {
                return NotFound();
            }

            db.Actors.Remove(actors);
            db.SaveChanges();

            return Ok(actors);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ActorsExists(int id)
        {
            return db.Actors.Count(e => e.ID == id) > 0;
        }
    }
}