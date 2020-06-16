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
    public class MathematicsController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Mathematics
        public IQueryable<Mathematics> GetMathematics()
        {
            return db.Mathematics;
        }
        [AllowAnonymous]
        // GET: api/Mathematics/5
        [ResponseType(typeof(MathematicsArticles))]
        public IHttpActionResult GetMathematicsArticles(int id)
        {
            MathematicsArticles mathematicsArticles = db.MathematicsArticles.Find(id);
            if (mathematicsArticles == null)
            {
                return NotFound();
            }

            return Ok(mathematicsArticles);
        }

        // PUT: api/Mathematics/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutMathematics(int id, Mathematics mathematics)
        {

            if (id != mathematics.ID)
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
                    $"EXEC MathematicsRating @id = '{mathematics.ID}'," +
                    $" @rating = '{mathematics.Rating}'";
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

        // POST: api/Mathematics
        [ResponseType(typeof(Mathematics))]
        public IHttpActionResult PostMathematics(Mathematics mathematics)
        {

            db.Mathematics.Add(mathematics);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (MathematicsExists(mathematics.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = mathematics.ID }, mathematics);
        }

        // DELETE: api/Mathematics/5
        [ResponseType(typeof(Mathematics))]
        public IHttpActionResult DeleteMathematics(int id)
        {
            Mathematics mathematics = db.Mathematics.Find(id);
            if (mathematics == null)
            {
                return NotFound();
            }

            db.Mathematics.Remove(mathematics);
            db.SaveChanges();

            return Ok(mathematics);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool MathematicsExists(int id)
        {
            return db.Mathematics.Count(e => e.ID == id) > 0;
        }
    }
}