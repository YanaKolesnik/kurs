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
    public class SpacesController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Spaces
        public IQueryable<Space> GetSpace()
        {
            return db.Space;
        }
        [AllowAnonymous]
        // GET: api/Spaces/5
        [ResponseType(typeof(SpaceArticles))]
        public IHttpActionResult GetSpaceArticles(int id)
        {
            SpaceArticles spaceArticles = db.SpaceArticles.Find(id);
            if (spaceArticles == null)
            {
                return NotFound();
            }

            return Ok(spaceArticles);
        }

        // PUT: api/Spaces/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutSpace(int id, Space space)
        {

            if (id != space.ID)
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
                    $"EXEC SpaceRating @id = '{space.ID}'," +
                    $" @rating = '{space.Rating}'";
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

        // POST: api/Spaces
        [ResponseType(typeof(Space))]
        public IHttpActionResult PostSpace(Space space)
        {

            db.Space.Add(space);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (SpaceExists(space.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = space.ID }, space);
        }

        // DELETE: api/Spaces/5
        [ResponseType(typeof(Space))]
        public IHttpActionResult DeleteSpace(int id)
        {
            Space space = db.Space.Find(id);
            if (space == null)
            {
                return NotFound();
            }

            db.Space.Remove(space);
            db.SaveChanges();

            return Ok(space);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool SpaceExists(int id)
        {
            return db.Space.Count(e => e.ID == id) > 0;
        }
    }
}