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
    public class PhysicsController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Physics
        public IQueryable<Physics> GetPhysics()
        {
            return db.Physics;
        }
        [AllowAnonymous]
        // GET: api/Physics/5
        [ResponseType(typeof(PhysicsArticles))]
        public IHttpActionResult GetPhysicsArticles(int id)
        {
            PhysicsArticles physicsArticles = db.PhysicsArticles.Find(id);
            if (physicsArticles == null)
            {
                return NotFound();
            }

            return Ok(physicsArticles);
        }

        // PUT: api/Physics/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutPhysics(int id, Physics physics)
        {

            if (id != physics.ID)
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
                    $"EXEC PhysicsRating @id = '{physics.ID}'," +
                    $" @rating = '{physics.Rating}'";
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

        // POST: api/Physics
        [ResponseType(typeof(Physics))]
        public IHttpActionResult PostPhysics(Physics physics)
        {

            db.Physics.Add(physics);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (PhysicsExists(physics.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = physics.ID }, physics);
        }

        // DELETE: api/Physics/5
        [ResponseType(typeof(Physics))]
        public IHttpActionResult DeletePhysics(int id)
        {
            Physics physics = db.Physics.Find(id);
            if (physics == null)
            {
                return NotFound();
            }

            db.Physics.Remove(physics);
            db.SaveChanges();

            return Ok(physics);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool PhysicsExists(int id)
        {
            return db.Physics.Count(e => e.ID == id) > 0;
        }
    }
}